function! ValidateGitLabCI()
python3 << EOF
import vim, json, os
from urllib import request, parse

data = vim.current.buffer

# setup request domain/token
base_domain = 'gitlab.com'

os_base_domain = os.getenv('VAL_GITLAB_CI_DOMAIN')
if os_base_domain:
    base_domain = os_base_domain

url = f'https://{base_domain}/api/v4/ci/lint'

token = os.getenv('VAL_GITLAB_CI_TOKEN')

# TODO error handling
if token is None:
    vim.command(f'echo "Missing Token"')

ci_data = ""
for x in data:
    ci_data+=(x + '\n')

# request ci lint API
body = {'content': ci_data}
body = json.dumps(body).encode('utf-8')
headers = {'content-type': 'application/json', 'PRIVATE-TOKEN': token}
req = request.Request(url, data=body, headers=headers)

# TODO error handling
response = request.urlopen(req).read().decode('UTF-8')
json_response = json.loads(response)

status = json_response['status']
warnings = json_response['warnings']
errors = json_response['errors']

commands = []
if status == 'valid':
  commands.append('hi Valid guifg=#00ff00 ctermfg=green')
  commands.append('echohl Valid | echon "✅ Your CI configuration is valid!" | echohl None')

else:
  commands.append('echohl Error | echon " Your CI configuration is invalid\n"')

  commands.append('echohl WarningMsg | echon "Errors: "')
  for error in errors:
    commands.append('echohl Statement')
    commands.append("echon '{}\n'".format(error))

# apparently the result can contain warnings even when it's valid(?)
if any(warnings):
  commands.append('echohl WarningMsg | echon "Warnings: "')
  for warning in warnings:
    commands.append("echohl Statement | echon '{}\n'".format(warning))

for cmd in commands:
  vim.command(cmd)

EOF
endfunction
command! -nargs=0 ValidateGitLabCI call ValidateGitLabCI()

import re
import json

def load_jsonc(s: str):
    return json.loads(re.sub(r'//.*$', '', s, re.M))

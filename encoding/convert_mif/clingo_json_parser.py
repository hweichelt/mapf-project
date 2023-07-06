import sys
import json

clingo_output_json = json.load(sys.stdin)
first_model_list = clingo_output_json.get('Call')[0].get('Witnesses')[0].get('Value')

print(".\n".join(first_model_list) + ".")

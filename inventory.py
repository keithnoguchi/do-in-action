#!/usr/bin/env python

import json
import argparse
import subprocess


def main():
    inventory = {'all': {'vars': {'ansible_user': 'root'}},
                 'client': {}, 'server': {}}
    inventory['client']['hosts'] = []
    inventory['server']['hosts'] = []
    inventory['all']['hosts'] = []
    hostvars = {}

    for type in ['client', 'server']:
        name = "%s%d" % (type, 0)
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().strip('\n')
        inventory[type]['hosts'].append(address)
        inventory['all']['hosts'].append(address)
        hostvars[address] = {'name': name}

    # noqa https://github.com/ansible/ansible/commit/bcaa983c2f3ab684dca6c2c2c8d1997742260761
    inventory['_meta'] = {'hostvars': hostvars}

    parser = argparse.ArgumentParser(description="DO server inventory")
    parser.add_argument('--list', action='store_true',
                        help="List DO server inventory")
    parser.add_argument('--host', help='List details of a host')
    args = parser.parse_args()

    if args.list:
        print(json.dumps(inventory))
    elif args.host:
        print(json.dumps(hostvars.get(args.host, {})))


if __name__ == '__main__':
    main()

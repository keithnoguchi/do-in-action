#!/usr/bin/env python

import json
import argparse
import subprocess

inventory = {'all': {'hosts': [], 'vars': {'ansible_user': 'root'}}}
hostvars = {}


def main():
    inventory['client'] = client(1)
    inventory['server'] = server(1)

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


def client(number):
    client = {'hosts': []}
    for i in range(number):
        name = "client%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().strip('\n')
        client['hosts'].append(address)
        inventory['all']['hosts'].append(address)
        hostvars[address] = {'name': name}

    return client


def server(number):
    server = {'hosts': []}
    for i in range(number):
        name = "server%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().strip('\n')
        server['hosts'].append(address)
        inventory['all']['hosts'].append(address)
        hostvars[address] = {'name': name}

    return server


if __name__ == '__main__':
    main()

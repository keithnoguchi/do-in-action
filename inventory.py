#!/usr/bin/env python

import json
import argparse
import subprocess


def main():
    inventory = {'all': {'hosts': [], 'vars': {'ansible_user': 'root'}}}

    inventory['client'] = client(1)
    inventory['server'] = server(1)

    hostvars = {}
    for type in ['client', 'server']:
        for host in inventory[type]['hosts']:
            inventory['all']['hosts'].append(host)
            hostvars[host] = {'name': host}

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
    client = {'hosts': [], 'vars': {'server': {}}}
    for i in range(number):
        name = "client%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().strip('\n')
        client['hosts'].append(address)

    # Setup the server variable.
    proc = subprocess.Popen("terraform output server0_public_ipv4",
                            shell=True, stdout=subprocess.PIPE)
    client['vars']['server']['ipv4'] = proc.stdout.read().strip('\n')
    proc = subprocess.Popen("terraform output server0_public_ipv6",
                            shell=True, stdout=subprocess.PIPE)
    client['vars']['server']['ipv6'] = proc.stdout.read().strip('\n')

    return client


def server(number):
    server = {'hosts': [], 'vars': {}}
    for i in range(number):
        name = "server%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().strip('\n')
        server['hosts'].append(address)

    return server


if __name__ == '__main__':
    main()

#!/usr/bin/env python

import json
import argparse
import subprocess


def main():
    inventory = {'all': {'hosts': [], 'vars': {'ansible_user': 'root'}}}
    hostvars = {}

    inventory['client'] = client(1, hostvars)
    inventory['server'] = server(1, hostvars)
    inventory['monitor'] = monitor(1, hostvars)

    for type in ['client', 'server', 'monitor']:
        for host in inventory[type]['hosts']:
            inventory['all']['hosts'].append(host)

    # noqa https://github.com/ansible/ansible/commit/bcaa983c2f3ab684dca6c2c2c8d1997742260761
    inventory['_meta'] = {'hostvars': hostvars}

    parser = argparse.ArgumentParser(description="DO droplet inventory")
    parser.add_argument('--list', action='store_true',
                        help="List DO droplet inventory")
    parser.add_argument('--host', help='List details of a droplet')
    args = parser.parse_args()

    if args.list:
        print(json.dumps(inventory))
    elif args.host:
        print(json.dumps(hostvars.get(args.host, {})))


def client(number, hostvars):
    client = {'hosts': []}
    for i in range(number):
        name = "client%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().decode('utf-8').strip('\n')
        client['hosts'].append(address)
        hostvars[address] = {'name': address, 'server': {}}

        # Setup the server related variables.
        proc = subprocess.Popen("terraform output server0_public_ipv4",
                                shell=True, stdout=subprocess.PIPE)
        hostvars[address]['server']['ipv4'] = proc.stdout.read().decode('utf-8').strip('\n')
        proc = subprocess.Popen("terraform output server0_private_ipv4",
                                shell=True, stdout=subprocess.PIPE)
        hostvars[address]['server']['ipv4_private'] = proc.stdout.read().decode('utf-8').strip('\n')
        proc = subprocess.Popen("terraform output server0_public_ipv6",
                                shell=True, stdout=subprocess.PIPE)
        hostvars[address]['server']['ipv6'] = proc.stdout.read().decode('utf-8').strip('\n')
        proc = subprocess.Popen("terraform output server_flip",
                                shell=True, stdout=subprocess.PIPE)
        hostvars[address]['server']['flip'] = proc.stdout.read().decode('utf-8').strip('\n')
        proc = subprocess.Popen("terraform output server_port",
                                shell=True, stdout=subprocess.PIPE)
        hostvars[address]['server']['port'] = proc.stdout.read().decode('utf-8').strip('\n')

    return client


def server(number, hostvars):
    server = {'hosts': [], 'vars': {'server': {}}}
    for i in range(number):
        name = "server%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().decode('utf-8').strip('\n')
        server['hosts'].append(address)
        hostvars[address] = {'name': address}

    # Setup the server related variables.
    proc = subprocess.Popen("terraform output server_port",
                            shell=True, stdout=subprocess.PIPE)
    server['vars']['server']['port'] = proc.stdout.read().decode('utf-8').strip('\n')

    return server


def monitor(number, hostvars):
    monitor = {'hosts': [], 'vars': {'server': {}}}
    for i in range(number):
        name = "monitor%d" % i
        proc = subprocess.Popen("terraform output %s_public_ipv4" % name,
                                shell=True, stdout=subprocess.PIPE)
        address = proc.stdout.read().decode('utf-8').strip('\n')
        monitor['hosts'].append(address)
        hostvars[address] = {'name': address}

    return monitor


if __name__ == '__main__':
    main()

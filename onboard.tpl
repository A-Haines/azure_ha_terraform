#cloud-config
write_files:
- content: |
    #!/bin/bash

      echo "This is installation is done with cloud-init configured by remo@f5.com" >> /var/tmp/cloud-init-output

    # Wait for MCPD to be up before running tmsh commands
      source /usr/lib/bigstart/bigip-ready-functions
      wait_bigip_ready

        #  Begin BIG-IP configuration
        tmsh modify sys disk directory /appdata new-size 25000000
        tmsh modify /sys global-settings mgmt-dhcp disabled
        tmsh modify /sys global-settings gui-setup disabled
        tmsh modify /sys sshd banner enabled banner-text 'Configured via Automation. All Sessions will be recorded!'
        tmsh modify /sys global-settings gui-security-banner-text 'Configured via Automation!'
        tmsh modify analytics global-settings \{ offbox-protocol tcp offbox-tcp-addresses add \{ 127.0.0.1 \} offbox-tcp-port 6514 use-offbox enabled \}
        tmsh save /sys config

  path: /config/custom-config.sh
  permissions: '0755'
  owner: root:root
  append: true
- content:
    path: /var/tmp/bootcmd_end
    owner: root:root
    permissions: '0644'
runcmd:
  - /config/custom-config.sh &
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - ${DO_URL}
    - ${AS3_URL}
    - ${TS_URL}
    - ${FAST_URL}
  do_declaration:
    schemaVersion: 1.0.0
    class: Device
    async: true
    label: Cloudinit Onboarding
    Common:
      hostname: ${bigip_hostname}
      class: Tenant
      provisioningLevels:
        class: Provision
        ltm: nominal
        asm: nominal
      admin:
        class: User
        shell: bash
        userType: regular
      myLicense:
        class: License
        licenseType: regKey
        regKey: ${license}
        overwrite: true
      internal:
        class: VLAN
        tag: 4093
        mtu: 1500
        interfaces:
          - name: 1.2
            tagged: false
      external:
        class: VLAN
        tag: 4094
        mtu: 1500
        interfaces:
          - name: 1.1
            tagged: false
      internal_self:
        class: SelfIp
        address: ${intselfip}/24
        vlan: internal
        allowService: default
        trafficGroup: traffic-group-local-only
      external_self:
        class: SelfIp
        address: ${extselfip}/24
        vlan: external
        allowService: none
        trafficGroup: traffic-group-local-only 
      configsync:
        class: ConfigSync
        configsyncIp: /Common/internal_self/address
      failoverAddress:
        class: FailoverUnicast
        address: /Common/internal_self/address
      failoverGroup:
        class: DeviceGroup
        type: sync-failover
        members:
          - ${host1} 
          - ${host2}
        owner: /Common/failoverGroup/members/0
        autoSync: true
        saveOnAutoSync: false
        networkFailover: true
        fullLoadOnSync: false
        asmSync: true
      trust:
        class: DeviceTrust
        localUsername: ${bigipuser}
        localPassword: ${bigippass}
        remoteHost: ${dscip}
        remoteUsername: ${bigipuser}
        remotePassword: ${bigippass}
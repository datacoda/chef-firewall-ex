require 'spec_helper'

describe 'fake::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '12.04',
      step_into: 'firewall_ex'
      ) do |node|
        node.set['virtualization']['system'] = 'openvz'
      end.converge('fake::default')
  end

  it 'includes firewall::default' do
    expect(chef_run).to install_package('ufw')
  end

  it 'allows ssh' do
    expect(chef_run).to allow_firewall_rule('ssh')
  end

  it 'creates firewall-ex resource' do
    expect(chef_run).to enable_firewall('my_ufw')

    # firewall does not manage the service ufw directly.
    # firewall-ex touches it later as a method to reload rules.

    ufw_service = chef_run.service('ufw')
    expect(ufw_service.performed_actions).to be_empty

    expect(chef_run).to enable_firewall_ex('my_ufw')

    expect(chef_run).to create_template('/etc/ufw/before.rules')
    expect(chef_run).to create_template('/etc/ufw/before6.rules')
    expect(chef_run).to create_template('/etc/ufw/after.rules')
    expect(chef_run).to create_template('/etc/ufw/after6.rules')

    expect(chef_run).to create_template('/etc/ufw/sysctl.conf')
    expect(chef_run).to create_template('/etc/default/ufw')
  end

  it 'it restarts service[ufw] based on rule changes' do
    before_rules = chef_run.template('/etc/ufw/before.rules')
    expect(before_rules).to notify('service[ufw]').to(:restart)

    before6_rules = chef_run.template('/etc/ufw/before6.rules')
    expect(before6_rules).to notify('service[ufw]').to(:restart)

    after_rules = chef_run.template('/etc/ufw/after.rules')
    expect(after_rules).to notify('service[ufw]').to(:restart)

    after6_rules = chef_run.template('/etc/ufw/after6.rules')
    expect(after6_rules).to notify('service[ufw]').to(:restart)

    sysctl_conf = chef_run.template('/etc/ufw/sysctl.conf')
    expect(sysctl_conf).to notify('service[ufw]').to(:restart)

    default_ufw = chef_run.template('/etc/default/ufw')
    expect(default_ufw).to notify('service[ufw]').to(:restart)
  end
end

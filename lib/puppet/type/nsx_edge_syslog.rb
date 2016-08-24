# Copyright (C) 2014-2016 VMware, Inc.
require 'pathname'
require 'ipaddr'
vmware_module = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
require File.join vmware_module.path, 'lib/puppet/property/vmware'

Puppet::Type.newtype(:nsx_edge_syslog) do
  @doc = 'Manage NSX edge syslog config'


  newparam(:scope_name, :namevar => true) do
    desc 'edge name, as listed in nsx manager ( must match exactly )'
    newvalues(/\w/)
  end

  newproperty(:protocol) do
    desc 'udp/tcp'
    newvalues(:udp,:tcp)
    defaultto(:udp)
  end

  newproperty(:server_addresses, :array_matching => :all, :sort => :false, :parent => Puppet::Property::VMware_Array ) do
    desc 'these are the syslog servers which nsx points to'
    defaultto([])
    validate do |value|
      # validate if valid ip address
      IPAddr.new "#{value}"
    end
  end

  newproperty(:enabled) do
    desc 'whether or not enabled, since defaulting to true'
    newvalues(:true,:false)
    defaultto(:true)
  end

  autorequire(:nsx_edge) do
    self[:name]
  end

end

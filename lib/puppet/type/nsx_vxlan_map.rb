# Copyright (C) 2014-2016 VMware, Inc.
require 'pathname'
vmware_module = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
require File.join vmware_module.path, 'lib/puppet/property/vmware'

Puppet::Type.newtype(:nsx_vxlan_map) do
  @doc = 'Map a cluster to a vDS.'

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end

  newparam(:vlan_id, :namevar => true) do
    desc 'vlan id'
    newvalues(/^\d{1,4}$/)
  end

  newproperty(:switch, :parent => Puppet::Property::VMware_Hash) do
    desc 'switch id'
    newvalues(/\w/)
  end

  newparam(:datacenter_name, :parent => Puppet::Property::VMware) do
    newvalues(/\w/)
  end

  newparam(:cluster_name, :parent => Puppet::Property::VMware) do
    newvalues(/\w/)
  end

  autorequire(:nsx_vxlan_switch) do
    self[:name]
  end

  autorequire(:transport) do
    self[:name]
  end

end

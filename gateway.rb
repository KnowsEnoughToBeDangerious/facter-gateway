#!/usr/bin/env ruby
# Custom fact that takes every interface and creates gateway_<ifname> fact for its gateway.
require 'facter'

# Get all interfaces using core fact :interfaces and put them into an array
interfaces = Facter.value(:interfaces).split(',')

#Loop through each interface to create fact for each
interfaces.each do |ifname|
  Facter.add("gateway_#{ifname}") do
    setcode do
      # Get core fact for network for each interface
      network = Facter.value("network_#{ifname}")
      # If network for interface is blank then skip
      if network.nil?
          next
      end
      # split network value by octet into array and make an int
      network = network.split('.').map(&:to_i)
      # Take each part of network array and reconstruct to ip with adding 1 at end for gateway
      gateway = "#{network[0]}.#{network[1]}.#{network[2]}.#{network[3] + 1}"
    end
  end
end

# Plugin to extend the virtualization attributes in a Xen Host
require_plugin 'virtualization'
provides 'virtualization_extensions'

if not virtualization.nil? and virtualization[:role] == 'host'
  # create a guest_list attributte listing all the guests running
  if virtualization[:emulator] == 'xen'
    virtualization[:guest_list] = Mash.new
    `xm list | egrep -v '^(Domain-0|Name)'`.each_line do |g|
      name, id, mem, vcpus, state, time = g.split
      virtualization[:guest_list][name] = Mash.new
      virtualization[:guest_list][name][:id] = id.strip
      virtualization[:guest_list][name][:vcpus] = vcpus.strip
      virtualization[:guest_list][name][:mem] = mem.strip
      virtualization[:guest_list][name][:time] = time.strip
      virtualization[:guest_list][name][:state] = state.strip
    end

    # create a host_info attribute with the info extracted from the xm info command
    virtualization[:host_info] = Mash.new
    from("xm info").each_line do |l|
      t = l.split(':')
      key = t[0]
      val = t[1..-1].join(':')
      virtualization[:host_info][key.to_sym] = val
    end
  else
    #not a xen host
  end
end

# Plugin to extend the virtualization attributes in a Xen Host
require_plugin 'virtualization'

if not virtualization.nil? and virtualization[:role] == 'host'
  # create a guest_list attributte listing all the guests running
  virtualization[:guest_list] = []
  from("xm list | awk '{ print $1 }' |egrep -v '^(Domain-0|Name)'").each_line do |g|
    virtualization[:guest_list] << g
  end

  # create a host_info attribute with the info extracted from the xm info command
  virtualization[:host_info][key.to_sym] = Mash.new
  from("xm info").each_line do |l|
    t = l.split(':')
    key = t[0]
    val = t[1..-1].join(':')
    virtualization[:host_info][key.to_sym] = val
  end
else
  #not a xen host
end


require_plugin 'virtualization'

if not virtualization.nil? and virtualization[:role] == 'host'
  virtualization[:guest_list] = []
  from("xm list | awk '{ print $1 }' |egrep -v '^(Domain-0|Name)'").each_line do |g|
    virtualization[:guest_list] << g
  end
else
  #not a xen host
end


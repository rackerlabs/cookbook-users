admins_group = node['users']['admins']['group']

# configure admins group
group admins_group do
  gid node['users']['admins']['gid']
end

template "/etc/sudoers.d/#{admins_group}" do
  owner 'root'
  group 'root'
  mode '0440'
  source 'sudoers.erb'
end

# manage users
search(:users, '*:*').each do |u|
  uid = u['uid']
  gid = u['gid']
  name = u['id']
  home = "/home/#{name}"

  # remove user
  if u.key?('action') && u['action'] == 'remove'
    directory "#{home}/.ssh" do
      action :delete
      recursive true
    end

    # if u['sudo']
    #   group admins_group do
    #     append true
    #     action :modify
    #     excluded_members [name]
    #   end
    # end

    # u['groups'].each do |grp|
    #   next if grp == admins_group
    #   group grp do
    #     append true
    #     action :modify
    #     excluded_members [name]
    #   end
    # end

    user name do
      uid uid
      gid gid
      action :remove
    end

    group name do
      gid gid
      action :remove
    end

    next
  end

  # add user
  group name do
    gid gid
  end

  user name do
    uid uid
    gid gid
    home home
    comment u['comment']
    supports manage_home: true
  end

  u['groups'].each do |grp|
    next if grp == admins_group
    group grp do
      append true
      action :modify
      members [name]
    end
  end

  if u['sudo']
    group admins_group do
      append true
      action :modify
      members [name]
    end
  end

  directory "#{home}/.ssh" do
    owner name
    group name
    mode '0700'
  end

  next unless u['ssh_keys'].any?
  template "#{home}/.ssh/authorized_keys" do
    owner name
    group name
    mode '0600'
    variables ssh_keys: u['ssh_keys']
  end
end

if defined?(ChefSpec)
  ChefSpec.define_matcher :firewall_ex

  def enable_firewall_ex(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:firewall_ex, :enable, resource_name)
  end

  # Temporary matcher since firewall cookbook is missing it.
  def enable_firewall(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:firewall, :enable, resource_name)
  end

  # Temporary matcher since firewall cookbook is missing it.
  def allow_firewall_rule(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:firewall_rule, :allow, resource_name)
  end
end

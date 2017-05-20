module SerializerAttribute
  def render?(values,name1,name2)
    values = values.map {|v| v.downcase}
    if instance_options[:render_attribute] == "all"
      true
    elsif values.include?(name1) || values.include?(name2)
      true
    else
      false
    end
  end
end

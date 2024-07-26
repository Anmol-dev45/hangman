require "msgpack"

module Serializable
  @@serializer = MessagePack

  def serialize
    obj = instance_variables.each_with_object({}) do |var, hash|
      hash[var] = instance_variable_get(var)
    end
    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.unpack(string)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end

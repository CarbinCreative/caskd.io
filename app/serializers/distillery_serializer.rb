# encoding: utf-8
class DistillerySerializer < ActiveModel::Serializer

  attributes :token, :name, :title
  attributes :phonetic, :respelling, :meaning
  attributes :description, :status

end

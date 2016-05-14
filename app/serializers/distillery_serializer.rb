# encoding: utf-8
class DistillerySerializer < ActiveModel::Serializer

  attributes :token, :name, :title, :slug
  attributes :phonetic, :respelling, :meaning
  attributes :description, :status

end

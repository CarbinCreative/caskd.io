# encoding: utf-8
require "test_helper"

class DistilleryTest < ActiveSupport::TestCase

  setup do
    Distillery.create(name: 'Ardbeg', title: 'Ardbeg', slug: 'ardbeg', phonetic: '/ɑːrdˈbɛɡ/', respelling: 'ard-beg', meaning: 'small headland')
  end

  test "should not create distillery without attributes" do
    distillery = Distillery.create
    assert_not distillery.valid?, "Required parameters missing!"
  end

  test "should not create existing distillery" do
    distillery = Distillery.create(name: 'Ardbeg', title: 'Ardbeg', slug: 'ardbeg')
    assert Distillery.exists?(slug: distillery.slug), "Record already exists!"
    distillery.save
    assert_not distillery.valid?, "Record already exists!"
  end

  test "should create new distillery" do
    initial_count = Distillery.count
    distillery = Distillery.create(name: 'Caol Ila', title: 'Caol Ila', slug: 'caol-ila', phonetic: '/kʊlˈaɪlə/', respelling: 'kuul-ee-lə', meaning: 'the sound of Islay')
    assert (initial_count + 1 == Distillery.count), "Did not save record!"
  end

  test "should have at least one operational distillery" do
    assert Distillery.operational.count > 0, "No records found"
  end

  test "should have at least one inoperative distillery" do
    Distillery.create(name: 'Glen Craig', title: 'Glen Craig', slug: 'glen-craig', status: "inoperative" )
    assert Distillery.inoperative.count > 0, "No records found"
  end

  test "should have at least one dormant distillery" do
    Distillery.create(name: 'Port Charlotte', title: 'Port Charlotte', slug: 'port-charlotte', status: "dormant" )
    assert Distillery.inoperative.count > 0, "No records found"
  end

end

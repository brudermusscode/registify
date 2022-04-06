require 'application_system_test_case'

class ListItemsTest < ApplicationSystemTestCase
  setup do
    @list_item = list_items(:one)
  end

  test 'visiting the index' do
    visit list_items_url
    assert_selector 'h1', text: 'List items'
  end

  test 'should create list item' do
    visit list_items_url
    click_on 'New list item'

    fill_in 'Users', with: @list_item.users_id
    fill_in 'Lists', with: @list_item.lists_id
    fill_in 'Text', with: @list_item.text
    click_on 'Create List item'

    assert_text 'List item was successfully created'
    click_on 'Back'
  end

  test 'should update List item' do
    visit list_item_url(@list_item)
    click_on 'Edit this list item', match: :first

    fill_in 'Users', with: @list_item.users_id
    fill_in 'Lists', with: @list_item.lists_id
    fill_in 'Text', with: @list_item.text
    click_on 'Update List item'

    assert_text 'List item was successfully updated'
    click_on 'Back'
  end

  test 'should destroy List item' do
    visit list_item_url(@list_item)
    click_on 'Destroy this list item', match: :first

    assert_text 'List item was successfully destroyed'
  end
end

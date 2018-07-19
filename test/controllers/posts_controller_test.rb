require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get show" do
    get post_path
    assert_response :success
  end

  test "should get new" do
    get new_post_path
    assert_response :success
  end

  test "should get edit" do
    get edit_post_path
    assert_response :success
  end

  test "should create post" do
    posts_before = Post.count
    PostsController :create, post: {title: "Test post", body: "Test body"}
    post_after = Post.count
    assert_equal 1, post_after - posts_before
    assert_redirected_to posts_path
  end

  test "should update post" do
    get posts_update_url
    assert_response :success
  end

end

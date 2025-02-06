require "test_helper"

class MusicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @music = musics(:one)
  end

  test "should get index" do
    get musics_url
    assert_response :success
  end

  test "should get new" do
    get new_music_url
    assert_response :success
  end

  test "should create music" do
    assert_difference("Music.count") do
      post musics_url, params: { music: { artist: @music.artist, country: @music.country, genre: @music.genre, label: @music.label, release_date: @music.release_date, tag: @music.tag, title: @music.title } }
    end

    assert_redirected_to music_url(Music.last)
  end

  test "should show music" do
    get music_url(@music)
    assert_response :success
  end

  test "should get edit" do
    get edit_music_url(@music)
    assert_response :success
  end

  test "should update music" do
    patch music_url(@music), params: { music: { artist: @music.artist, country: @music.country, genre: @music.genre, label: @music.label, release_date: @music.release_date, tag: @music.tag, title: @music.title } }
    assert_redirected_to music_url(@music)
  end

  test "should destroy music" do
    assert_difference("Music.count", -1) do
      delete music_url(@music)
    end

    assert_redirected_to musics_url
  end
end

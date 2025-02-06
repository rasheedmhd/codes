require "application_system_test_case"

class MusicsTest < ApplicationSystemTestCase
  setup do
    @music = musics(:one)
  end

  test "visiting the index" do
    visit musics_url
    assert_selector "h1", text: "Musics"
  end

  test "should create music" do
    visit musics_url
    click_on "New music"

    fill_in "Artist", with: @music.artist
    fill_in "Country", with: @music.country
    fill_in "Genre", with: @music.genre
    fill_in "Label", with: @music.label
    fill_in "Release date", with: @music.release_date
    fill_in "Tag", with: @music.tag
    fill_in "Title", with: @music.title
    click_on "Create Music"

    assert_text "Music was successfully created"
    click_on "Back"
  end

  test "should update Music" do
    visit music_url(@music)
    click_on "Edit this music", match: :first

    fill_in "Artist", with: @music.artist
    fill_in "Country", with: @music.country
    fill_in "Genre", with: @music.genre
    fill_in "Label", with: @music.label
    fill_in "Release date", with: @music.release_date
    fill_in "Tag", with: @music.tag
    fill_in "Title", with: @music.title
    click_on "Update Music"

    assert_text "Music was successfully updated"
    click_on "Back"
  end

  test "should destroy Music" do
    visit music_url(@music)
    click_on "Destroy this music", match: :first

    assert_text "Music was successfully destroyed"
  end
end

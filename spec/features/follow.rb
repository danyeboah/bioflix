require 'spec_helper'

feature "follow another user" do
  given!(:action) {Fabricate(:category)}
  given!(:movie1) {Fabricate(:video, title: "Scandal", category: action)}
  given!(:movie2) {Fabricate(:video, title: "Lost", category: action)}
  given!(:movie3) {Fabricate(:video, title: "Shiva", category: action)}

  given!(:user1) {Fabricate(:user)}
  given!(:user2) {Fabricate(:user)}

  given!(:review1) {Fabricate(:review, user: user2, video: movie1)}

  background do
    feature_sign_in(user1)
    find("a[href='/videos/#{movie1.slug}']").click
    find("a[href='/users/#{user2.slug}']").click
    click_link("Follow")
  end

  scenario "add person followed to people's list" do
    expect(page).to have_content("#{user2.first_name} #{user2.last_name}")
  end

  scenario "remove person followed from people's list" do
    within(:xpath, "//tr[contains(.,'#{user2.last_name}')]") do
      find("a[data-method='delete']").click
    end

    within("table") do
      expect(page).to_not have_content("#{user2.last_name}")
    end
  end





end
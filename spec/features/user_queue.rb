require 'spec_helper'

feature "add videos to user queue" do
  given!(:action) {Fabricate(:category)}
  given!(:movie1) {Fabricate(:video, title: "Scandal", category: action)}
  given!(:movie2) {Fabricate(:video, title: "Lost", category: action)}
  given!(:movie3) {Fabricate(:video, title: "Shiva", category: action)}

  background do
    feature_sign_in
    find("a[href='/videos/#{movie1.slug}']").click
    click_link("+My Queue")

    visit videos_path
    find("a[href='/videos/#{movie2.slug}']").click
    click_link("+My Queue")

    visit videos_path
    find("a[href='/videos/#{movie3.slug}']").click
    click_link("+My Queue")
  end

  scenario "my queue button removed when video already added to my queue" do
    find("a[href='/videos/#{movie1.slug}']").click
    find_link("Video Is In Your Queue").visible?
  end

  scenario "video order is correct in my queue" do
    expect(find(:xpath, "//tr[contains(.,'#{movie1.title}')]//input[@name = 'queue_items[][position]']").value).to eq("1")  
    expect(find(:xpath, "//tr[contains(.,'#{movie2.title}')]//input[@name = 'queue_items[][position]']").value).to eq("2")  
    expect(find(:xpath, "//tr[contains(.,'#{movie3.title}')]//input[@name = 'queue_items[][position]']").value).to eq("3")  

  end

  scenario "reorder videos in my queue" do
    within(:xpath, "//tr[contains(.,'#{movie1.title}')]") do
      fill_in "queue_items[][position]", with: 3
    end

    within(:xpath, "//tr[contains(.,'#{movie2.title}')]") do
      fill_in "queue_items[][position]", with: 1
    end
    
    within(:xpath, "//tr[contains(.,'#{movie3.title}')]") do
      fill_in "queue_items[][position]", with: 2
    end

    click_button('Update Instant Queue')

    expect(find(:xpath, "//tr[contains(.,'#{movie1.title}')]//input[@name = 'queue_items[][position]']").value).to eq("3")  
    expect(find(:xpath, "//tr[contains(.,'#{movie2.title}')]//input[@name = 'queue_items[][position]']").value).to eq("1")  
    expect(find(:xpath, "//tr[contains(.,'#{movie3.title}')]//input[@name = 'queue_items[][position]']").value).to eq("2")  
  end
  
end
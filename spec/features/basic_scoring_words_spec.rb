require 'spec_helper'

describe "the basic scoring of a word" do
  describe "/words" do
    xit "allows the input of a word and returns a score" do
      visit '/words'
      fill_in 'word[word]', :with => "hello"
      click_link_or_button 'Score Phrase'
      expect(current_path).to eq '/words'
      within('#last_phrase') do
        within('#phrase') do
          expect(page).to have_content('hello')
        end
        within('#score') do
          expect(page).to have_content('8')
        end
      end
    end

    xit "does not score a blank input" do
      visit '/words'
      fill_in 'word[word]', :with => ""
      click_link_or_button 'Score Phrase'
      expect(current_path).to eq '/words'
      within("#flash") do
        expect(page).to have_content("Sorry, please enter at least one word made up of only letters")
      end
    end

    xit "rejects words with non-letter characters" do
      ['exclaim!', '37numbers'].each do |word|
        visit '/words'
        fill_in 'word[word]', :with => word
        click_link_or_button 'Score Phrase'
        expect(current_path).to eq '/words'
        within("#flash") do
          expect(page).to have_content("Sorry, please enter at least one word made up of only letters")
        end
      end
    end

    xit "scores a phrase" do
      fish = "one fish two fish red fish blue fish"
      visit '/words'
      fill_in 'word[word]', :with => fish
      click_link_or_button 'Score Phrase'
      expect(current_path).to eq '/words'
      within('#last_phrase') do
        within('#phrase') do
          expect(page).to have_content(fish)
        end
        within('#score') do
          expect(page).to have_content('59')
        end
      end
      within("#previous_phrases") do
        expect(page).to have_content("fish: 10")
      end
    end

    context "with three words already scored" do
      let(:sample_words){ [['hello', 8], ['home', 9], ['sound', 6]] }

      before(:each) do
        sample_words.each do |word, score|
          visit '/words'
          fill_in 'word[word]', :with => word
          click_link_or_button 'Score Phrase'
        end
      end

      xit "displays the last three words along with their scores" do
        within("#previous_phrases") do
          sample_words.each do |word, score|
            expect(page).to have_content(word)
            expect(page).to have_content(score)
          end
        end
      end
    end

  end
end

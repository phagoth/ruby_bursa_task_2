require './library_manager.rb'

describe LibraryManager do

  let(:leo_tolstoy) { Author.new(1828, 1910, 'Leo Tolstoy' ) }
  let(:oscar_wilde) { Author.new(1854, 1900, 'Oscar Wilde') }
  let(:war_and_peace) { PublishedBook.new(leo_tolstoy, 'War and Peace', 1400, 3280, 1996) }
  let(:dorian_gray) { PublishedBook.new(oscar_wilde, 'The Picture of Dorian Gray', 580, 192, 2004) }
  let(:ivan_testenko) { ReaderWithBook.new('Ivan Testenko', 16, war_and_peace, 328) }
  let(:mark_testenko) { ReaderWithBook.new('Mark Testenko', 12, dorian_gray, 48) }
  let(:manager) { LibraryManager.new(ivan_testenko, (DateTime.now.new_offset(0) - 2.days)) }
  let(:manager2) { LibraryManager.new(ivan_testenko, (DateTime.now.new_offset(0) - 100.hours)) }
  let(:manager3) { LibraryManager.new(mark_testenko, (DateTime.now.new_offset(0) - 3.days)) }
  let(:manager4) { LibraryManager.new(mark_testenko, (DateTime.now.new_offset(0) - 200.hours)) }

  it 'should count penalty' do
    res = manager.penalty
    expect(res).to eq 784
  end

  it 'should know if author can meet another author' do
    manager.could_meet_each_other? leo_tolstoy, oscar_wilde
  end

  it 'should count days to buy' do
    res = manager.days_to_buy
    expect(res).to eq 4
  end

  it 'should transliterate ukrainian names' do
    ukrainan_author = Author.new(1856, 1916, 'Іван Франко')
    res = manager.transliterate ukrainan_author
    expect(res).to eq 'Ivan Franko'
  end

  it 'should count penalty to finish' do
    res = manager.penalty_to_finish
    expect(res).to eq 3790
  end

  it 'should compose email notifications' do
    expect(manager.email_notification). to eq <<-TEXT
Hello, Ivan Testenko!

You should return a book War and Peace authored by Leo Tolstoy in -48 hours.
Otherwise you will be charged 16.338 per hour.
TEXT
  end

end

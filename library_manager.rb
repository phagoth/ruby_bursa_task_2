require 'active_support/all'
require 'pry'

require './author.rb'
require './book.rb'
require './published_book.rb'
require './reader.rb'
require './reader_with_book.rb'

class LibraryManager

  attr_accessor :reader_with_book, :issue_datetime

  def initialize reader_with_book, issue_datetime
    @reader_with_book = reader_with_book
    @issue_datetime = issue_datetime
  end

  def penalty_for_hour published_book # reader_with_book.book
    return published_book.price * ( 0.00007 * (DateTime.now.year - published_book.published_at) + 0.000003 * published_book.pages_quantity + 0.0005)
  end

  def penalty
    penalty_hours = ((DateTime.now - issue_datetime).to_f * 24).round
    res = if penalty_hours > 0
            penalty_hours * penalty_for_hour(reader_with_book.book)
          else
            0
          end
    return res.round
  end

  def could_meet_each_other? first_author, second_author
    return first_author.can_meet?(second_author)
  end

  def days_to_buy
    penaltyHours = reader_with_book.book.price / penalty_for_hour(reader_with_book.book)
    return (penaltyHours / 24).round
  end

def transliterate author
    translit = author.name
    ukrLetters = ['А', 'а', 'Б', 'б', 'В', 'в', 'Г', 'г', 'Ґ', 'ґ', 'Д', 'д', 'Е', 'е',
                  'Є', 'є', 'Ж', 'ж', 'З', 'з', 'И', 'и', 'І', 'і', 'Ї', 'ї', 'Й', 'й',
                  'К', 'к', 'Л', 'л', 'М', 'м', 'Н', 'н', 'О', 'о', 'П', 'п', 'Р', 'р',
                  'С', 'с', 'Т', 'т', 'У', 'у', 'Ф', 'ф', 'Х', 'х', 'Ц', 'ц',
                  'Ч', 'ч', 'Ш', 'ш', 'Щ', 'щ', 'Ь', 'ь', 'Ю', 'ю', 'Я', 'я']
    engLetters = ['A', 'a', 'B', 'b', 'V', 'v', 'H', 'h', 'G', 'g', 'D', 'd', 'E', 'e',
                  'Ye', 'ie', 'Zh', 'zh', 'Z', 'z', 'Y', 'y', 'I', 'i', 'Yi', 'i', 'Y', 'i',
                  'K', 'k', 'L', 'l', 'M', 'm', 'N', 'n', 'O', 'o', 'P', 'p', 'R', 'r',
                  'S', 's', 'T', 't', 'U', 'u', 'F', 'f', 'Kh', 'kh', 'Ts', 'ts',
                  'Ch', 'ch', 'Sh', 'sh', 'Shch', 'shch', '', '', 'Yu', 'iu', 'Ya', 'ia']

    for i in 0..ukrLetters.length-1
      translit.gsub!(ukrLetters[i], engLetters[i])
    end

    return translit
  end

  def penalty_to_finish
    timeToRead = reader_with_book.time_to_finish / 24.0
    endReading = DateTime.now + timeToRead
    res = if endReading > issue_datetime
      penaltyHours = ((endReading - issue_datetime).to_f * 24).round
      penaltyHours * penalty_for_hour(reader_with_book.book)
    else
      0
    end
    return res.round
  end

  def email_notification_params
      {
        penalty: penalty_for_hour(reader_with_book.book),
        hours_to_deadline: ((issue_datetime - DateTime.now).to_f * 24).round,
      }
  end

  def email_notification
    #use email_notification_params
    return "Hello, #{reader_with_book.name}!

You should return a book #{reader_with_book.book.title} authored by #{reader_with_book.book.author.name} in #{email_notification_params[:hours_to_deadline]} hours.
Otherwise you will be charged #{email_notification_params[:penalty]} per hour.
"
  end

end

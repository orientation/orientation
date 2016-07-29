class SearchSnippet
  PRE_MATCHED_CHAR_LENGTH = 100
  POST_MATCHED_CHAR_LENGTH = 100
  OMISSION_INDICATOR = '...'
  attr_accessor :content

  def initialize(input_query, content, options = {})
    @input_query = input_query
    @content = content
    @pre_matched_char_length = options[:pre_matched_char_length] || PRE_MATCHED_CHAR_LENGTH
    @post_matched_char_length = options[:post_matched_char_length] || POST_MATCHED_CHAR_LENGTH
  end

  def pre_matched_text
    if match?
      formatted_pre_matched_text
    else
      ''
    end
  end

  def post_matched_text
    if match?
      formatted_post_matched_text
    else
      ''
    end
  end

  def match?
    matched_index != nil
  end

  def query
    if match?
      @input_query
    else
      ''
    end
  end

  private

  def formatted_pre_matched_text
    matched_text = content[*pre_matched_range]

    if matched_text[0] == ' '
      OMISSION_INDICATOR + matched_text.lstrip
    elsif close_to_begining_of_doc?
      matched_text
    else
      rspace = matched_text[-1] == ' ' ? ' ' : ''
      matched_words = matched_text.split(' ')[1..-1]
      OMISSION_INDICATOR + matched_words.join(' ') + rspace
    end
  end

  def formatted_post_matched_text
    matched_text = content[matched_index + query.length, @post_matched_char_length]

    if close_to_end_of_doc?
      matched_text
    else
      lspace = matched_text[0] == ' ' ? ' ' : ''
      matched_words = matched_text.split(' ')[0...-1]
      lspace + matched_words.join(' ') + OMISSION_INDICATOR
    end
  end

  def pre_matched_range
    if close_to_begining_of_doc?
      [0, matched_index]
    else
      [matched_index - @pre_matched_char_length, @pre_matched_char_length]
    end
  end

  def close_to_begining_of_doc?
    matched_index <= @pre_matched_char_length
  end

  def close_to_end_of_doc?
    content.length <= matched_index + @post_matched_char_length
  end

  def matched_index
    if @input_query.present?
      @matched_index ||= content.index(/#{@input_query}/i)
    end
  end
end

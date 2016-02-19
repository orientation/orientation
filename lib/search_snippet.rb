class SearchSnippet
  PRE_MATCHED_CHAR_LENGTH = 75
  POST_MATCHED_CHAR_LENGTH = 75
  OMISSION_INDICATOR = '...'
  attr_accessor :content

  def initialize(input_query, content)
    @input_query = input_query
    @content = content
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
    matched_text = content[matched_index + query.length, POST_MATCHED_CHAR_LENGTH]

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
      [matched_index - PRE_MATCHED_CHAR_LENGTH, PRE_MATCHED_CHAR_LENGTH]
    end
  end

  def close_to_begining_of_doc?
    matched_index <= PRE_MATCHED_CHAR_LENGTH
  end

  def close_to_end_of_doc?
    content.length <= matched_index + POST_MATCHED_CHAR_LENGTH
  end

  def matched_index
    if @input_query.present?
      @matched_index ||= content.index(@input_query)
    end
  end
end

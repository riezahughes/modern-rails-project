module PageNumbering
  extend ActiveSupport::Concern

  PDF_NUMBERING_OPTIONS = {text_valign: :bottom, text_align: :right, max_font_size: 12}

  def do_numbering
    return unless self.number_pages?

    if pdf_document
      @skip_odd = skip_odd
      @skip_even = skip_even

      pdf = read_pdf pdf_document.path

      skip_set = pages_to_skip

      pages = pages_to_number pdf, skip_set

      start_page = last_disclosure_page
      first_page = nil
      last_numbered = start_page + 1
      pages.count.times do |i|
        first_page = last_numbered if first_page.nil?

        apply_numbering last_numbered, pages[i]

        last_numbered += 1
      end

      pdf.save pdf_document.path
      update first_page: first_page, last_page: last_numbered-1
      save!
      last_numbered-1
    end
  end

  def apply_numbering(page_number, page)
    if page.orientation == :landscape
      page[:Rotate] = 90
      page.fix_rotation.textbox " #{page_number} ", PDF_NUMBERING_OPTIONS
    else
      page.textbox " #{page_number} ", PDF_NUMBERING_OPTIONS
    end
  end

  def pages_to_number(pdf, skip_set)
    if @skip_even
      pages = odd_pages pdf, skip_set
    elsif @skip_odd
      pages = even_pages pdf, skip_set
    else
      pages = pdf.pages.select.with_index { |p, i| !(skip_set.include? i+1) }
    end
    pages
  end

  def odd_pages(pdf, skip_set)
    pdf.pages.select.with_index { |p, i| i.even? && !(skip_set.include? i+1) }
  end

  def even_pages(pdf, skip_set)
    pdf.pages.select.with_index { |p, i| i.odd? && !(skip_set.include? i+1) }
  end

  def pages_to_skip
    return [] unless skip_pages

    pages_array = skip_pages.split ','
    to_skip = []
    pages_array.each do |page|
      if page =~ /\A[\d]+\Z/
        to_skip << page.to_i
      elsif page =~ /\d+\-\d+/
        to_skip.push eval(page.gsub(/\-/, '..')).to_a
      end
    end

    pages = to_skip.flatten.uniq
    return pages.select { |page| page.even? } if @skip_odd
    return pages.select { |page| page.odd? } if @skip_even
    pages
  end

  def last_disclosure_page
    client_file.last_disclosure_page
  end

  def read_pdf(path)
    CombinePDF.load path
  end

end
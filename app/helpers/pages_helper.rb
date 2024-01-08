module PagesHelper
  def inline_styles(readonly)
    return "background-color: #f8f9fa; border: 1px solid #ced4da; color: #6c757d; cursor: not-allowed;" if readonly
    ''
  end
end

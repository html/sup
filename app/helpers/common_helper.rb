module CommonHelper
  def material_info(item)
    if item.info.blank?
      "Нет доступной информации о материале"
    else
      h item.info
    end
  end
end

module ApplicationHelper
  def avatar_url
    if current_user.photo
      @avatar_url = cl_image_path current_user.photo.path, height: 150, width: 150, crop: :thumb, gravity: :face
    elsif current_user.facebook_picture_url
      @avatar_url = current_user.facebook_picture_url
    else
      @avatar_url = image_url "logo-blue.png"
    end
  end
end

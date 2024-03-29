class Notify
  class << self
    def user(to, obj)
      fcm = FCM.new('AAAApe0tnzk:APA91bFppdbmBNvhPKgBHlJTl7Tg041ZtsYOt6wAgQlfz8g39WdBle_7C7A2JQ4T1pAlE2mXHeG7OkslWMBGABOPvqToZQos_wFMlHXAb_N3oL-QSLmdhX5Ytqqat72pE_ayyPXVdK3U')
      registration_ids= [to.to_s] 
      options = {
              priority: "high",
              collapse_key: "updated_score", 
              notification: {
                title: obj[:title], 
                body: obj[:body],
                icon: obj[:icon]
              }
            }
      response = fcm.send(registration_ids, options)
    end

    def group(group_type, obj)
      fcm = FCM.new('AAAApe0tnzk:APA91bFppdbmBNvhPKgBHlJTl7Tg041ZtsYOt6wAgQlfz8g39WdBle_7C7A2JQ4T1pAlE2mXHeG7OkslWMBGABOPvqToZQos_wFMlHXAb_N3oL-QSLmdhX5Ytqqat72pE_ayyPXVdK3U')
      registration_ids = []
      user = User.where.not(role: :admin)
      if group_type == 'technician'
        registration_ids = user.where(role: :technician).pluck(:firebase_token)
      elsif group_type == 'customer'
        registration_ids = user.where(role: :customer).pluck(:firebase_token)
      else
        registration_ids = user.pluck(:firebase_token)
      end

      options = {
              priority: "high",
              collapse_key: "updated_score", 
              notification: {
                  title: obj[:title], 
                  body: obj[:body],
                  icon: obj[:icon]
              }
            }
      response = fcm.send(registration_ids, options)
    end
  end
end
  
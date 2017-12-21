require 'aws-sdk'

module S3Upload

  def s3_initialaze(file_name, bucket)
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(bucket)
    @obj = bucket.object(file_name)
  end

  def upload_file(file, bucket)
    file_name = Time.now.to_i.to_s
    s3_initialaze(file_name, bucket)
    body = Base64.decode64(file.split(',')[1])
    @obj.put(body: body, acl: 'public-read', content_type: 'image/jpeg', content_encoding: 'base64')
    @file_link = 'https://s3-eu-central-1.amazonaws.com/' + bucket + '/' + file_name
  end

  def delete_file(file_link, bucket)
    file_name = file_link.split('/')[-1]
    s3_initialaze(file_name, bucket)
    @obj.delete
  end

  def update_file(new_file, old_file_link, bucket)
    delete_file(old_file_link, bucket)
    upload_file(new_file, bucket)
  end

end

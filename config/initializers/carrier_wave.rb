if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAIQIZRIUBPSNQA45A'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['dacsampleapp']
  end
end
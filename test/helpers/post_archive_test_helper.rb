module PostArchiveTestHelper
  def mock_post_archive_service!
    mock_sqs_service = Class.new do
      def send_message(msg)
        _, json = msg.split(/\n/)
        json = JSON.parse(json)
        prev = PostArchive.where(pool_id: json["post_id"]).order("id desc").first
        if prev && prev.updater_ip_addr.to_s == json["updater_ip_addr"]
          prev.update_columns(json)
        else
          PostArchive.create(json)
        end
      end
    end

    PostArchive.stubs(:sqs_service).returns(mock_sqs_service.new)
  end

  def start_post_archive_transaction
    PostArchive.connection.begin_transaction joinable: false
  end

  def rollback_post_archive_transaction
    PostArchive.connection.rollback_transaction
  end
end

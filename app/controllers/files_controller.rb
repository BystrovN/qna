class FilesController < ApplicationController
  def destroy
    return head :forbidden unless current_user.author_of?(file.record)

    file.purge
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end

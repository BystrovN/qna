class LinksController < ApplicationController
  def destroy
    return head :forbidden unless current_user.author_of?(link.linkable)

    link.destroy
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
end

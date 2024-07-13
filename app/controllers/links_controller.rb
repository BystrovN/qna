class LinksController < ApplicationController
  authorize_resource

  def destroy
    link.destroy
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
end

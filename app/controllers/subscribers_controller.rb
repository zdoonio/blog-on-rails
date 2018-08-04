class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.create(subscriber_params)
    if @subscriber.save
      flash[:notice] = "You have subscribed our blog. Thank you!"
      redirect_to root_path
    else
      flash[:alert] = "Not valid e-mail format."
      redirect_to new_subscriber_path
    end
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end

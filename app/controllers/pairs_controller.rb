class PairsController < ApplicationController

  
  def index
  end


  def new
    @pair = Pair.new
  end

  def create
    @pair = Pair.new(pair_params) 
    if @pair.save
      current_user.update(pair_id:@pair.id) # ✅ ユーザーにペアを紐づけ！
      redirect_to root_path, notice: "ペアを作成しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def pair_params
    params.require(:pair).permit(:anniversary)
  end



end

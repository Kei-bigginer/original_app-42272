require 'rails_helper'

RSpec.describe Moment, type: :model do
  describe 'デート記録の保存' do
    let(:moment) { build(:moment) } # Factoryで作成（保存はまだしない）

    context '保存できるとき' do
      it 'すべての情報が正しく入っていれば保存できる' do
        expect(moment).to be_valid
      end
    end

    context '保存できないとき' do
      it 'dateが空では保存できない' do
        moment.date = nil
        moment.valid?
        expect(moment.errors.full_messages).to include("日付 を入力してください")
      end

      it 'memoが空では保存できない' do
        moment.memo = ''
        moment.valid?
        expect(moment.errors.full_messages).to include("コメント を入力してください")
      end

      it 'imageが添付されていなければ保存できない' do
        moment.image = nil
        moment.valid?
        expect(moment.errors.full_messages).to include("画像 を添付してください")
      end

      it '未来日では保存できない' do
        moment.date = Date.today + 1
        moment.valid?
        expect(moment.errors.full_messages).to include("日付 は今日以前の日付を選んでください")
      end
      
    end
  end
end
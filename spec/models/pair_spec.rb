require 'rails_helper'

RSpec.describe Pair, type: :model do
  describe 'バリデーションのテスト' do
    context '正常な内容の場合' do
      it '有効なデータなら保存できる' do
        pair = FactoryBot.build(:pair)
        expect(pair).to be_valid
      end
    end

    context 'invite_code に関する異常系' do
      # invite_code が空だと保存できない（このテストは不要）
      # 自動生成の仕様があるなら空にならない前提でよい
      # it 'invite_code が空だと保存できない' do
      #   pair = FactoryBot.build(:pair)
      #   pair.invite_code = nil
      #   pair.valid?
      #   expect(pair.errors[:invite_code]).to include("を入力してください")
      # end

      it 'invite_code が重複していると保存できない' do
        # 先に1件保存（同じ invite_code にする）
        existing = FactoryBot.create(:pair)
        # 強制的に同じinvite_codeをセット（バリデーションより後で代入）
        duplicate = FactoryBot.build(:pair)
        duplicate.invite_code = existing.invite_code
        duplicate.valid?
        expect(duplicate.errors[:invite_code]).to include("はすでに存在します")
      end
    end
  end
end

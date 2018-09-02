require "termquickrpg"
require "termquickrpg/world/layer"

RSpec.describe TermQuickRPG::World::Layer do
  describe "#data" do
    let(:data) { ["asdf", "12345678"] }
    let(:layer) { TermQuickRPG::World::Layer.new(data) }

    it "returns the initial data" do
      expect(layer.data).to eq(data)
    end
  end

  describe "#==" do
    let(:data) { ["asdf", "12345678"] }
    let(:layer) { TermQuickRPG::World::Layer.new(data) }
    let(:similar_layer) { TermQuickRPG::World::Layer.new(data) }
    let(:other_layer) { TermQuickRPG::World::Layer.new(["x", "y"]) }

    it "a == a" do
      expect(layer).to eq(layer)
    end

    it "a1 == a2" do
      expect(layer).to eq(similar_layer)
    end

    it "a != b" do
      expect(layer).to_not eq(other_layer)
    end
  end

  describe "#cutout of 10x4 layer" do
    let(:data) {
      ["a123456789",
       "b123456789",
       "c123456789",
       "d123456789"]
    }
    let(:layer) { TermQuickRPG::World::Layer.new(data) }

    context "passing 0,0,0,0" do
      it "returns the whole layer" do
        expect(layer.cutout(0, 0, 0, 0)).to eq(layer)
      end
    end

    context "passing offset of 2,1" do
      let(:remainder) {
        TermQuickRPG::World::Layer.new(["23456789",
                                        "23456789",
                                        "23456789"])
      }

      context "sizes == 0,0" do
        it "returns the remainder after the offset" do
          expect(layer.cutout(2, 1, 100, 100)).to eq(remainder)
        end
      end

      context "size out of bound" do
        it "returns the remainder after the offset" do
          expect(layer.cutout(2, 1, 100, 100)).to eq(remainder)
        end
      end

      context "size == 8x3 (exact remainder)" do
        it "returns the remainder after the offset" do
          expect(layer.cutout(2, 1, 8, 3)).to eq(remainder)
        end
      end

      context "size == 3x2" do
        let(:remainder) { TermQuickRPG::World::Layer.new(["234", "234"]) }
        it "returns limited cutout" do
          expect(layer.cutout(2, 1, 3, 2)).to eq(remainder)
        end
      end
    end
  end

  describe "#draw" do
    let(:layer) { TermQuickRPG::World::Layer.new(["12","34"]) }
    let(:canvas) { double("canvas") }
    it "draws all chars into canvas" do
      expect(canvas).to receive(:draw).with("1", 0, 0)
      expect(canvas).to receive(:draw).with("2", 1, 0)
      expect(canvas).to receive(:draw).with("3", 0, 1)
      expect(canvas).to receive(:draw).with("4", 1, 1)
      layer.draw(canvas)
    end
  end
end

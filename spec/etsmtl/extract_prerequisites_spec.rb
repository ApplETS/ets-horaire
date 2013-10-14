# encoding: UTF-8

require_relative '../../app/etsmtl/extract_prerequisites'

shared_context 'prerequisite parsing' do
  let(:prerequisite_text) { self.class.description }
  subject { ExtractPrerequisites.from prerequisite_text }

  def relation_double(relation_type, courses_dictionary)
    courses = courses_dictionary.each_pair.collect do |course_type, course_names|
      course_names.collect do |course_name|
        course = double
        ExtractPrerequisites::Course.should_receive(:new).once.with(course_name, course_type).and_return course
        course
      end
    end
    courses = courses.flatten

    relation = double
    ExtractPrerequisites::Relation.should_receive(:new).once.with(relation_type, courses).and_return relation
    relation
  end
end

describe ExtractPrerequisites do
  include_context 'prerequisite parsing'

  context '(MAT145)' do
    it 'should return MAT145 as a prerequisite' do
      mat145 = double
      PrerequisiteCourse.should_receive(:new).once.with('mat145', :prerequisite).and_return mat145

      courses = [mat145]

      expected_prerequisites = double
      PrerequisiteProfile.should_receive(:new).once.with(:all, courses).and_return expected_prerequisites

      prerequisites_text = self.class.description
      prerequisites = ExtractPrerequisites.from(prerequisites_text)
      expected_prerequisites.should == prerequisites
    end

    #let!(:prerequisites) { { prerequisite: %w(MAT145) } }
    #let!(:and_relation) { relation_double :and, prerequisites }
    #it('should return MAT145 as a prerequisite') { should == and_relation }
  end

  #context '(CTN504*)' do
  #  let!(:prerequisites) { { prerequisite_or_concurrent: %w(CTN504) } }
  #  let!(:and_relation) { relation_double :and, prerequisites }
  #  it('should return CTN504 as a prerequisite or a concurrent course') { should == and_relation }
  #end
  #
  #context '(CTN308, MAT165)' do
  #  let!(:prerequisites) { { prerequisite: %w(CTN308 MAT165) } }
  #  let!(:and_relation) { relation_double :and, prerequisites }
  #  it('should return CTN308 and MAT165 as prerequisites') { should == and_relation }
  #end
  #
  #context '(CTN200,GIA400)' do
  #  let!(:prerequisites) { { prerequisite: %w(CTN200 GIA400) } }
  #  let!(:and_relation) { relation_double :and, prerequisites }
  #  it('should return CTN200 and GIA400 as prerequisites') { should == and_relation }
  #end
  #
  #context '(INF135, MEC329*)' do
  #  let!(:prerequisites) { {
  #      prerequisite: %w(INF135),
  #      prerequisite_or_concurrent: %w(MEC329)
  #  } }
  #  let!(:and_relation) { relation_double :and, prerequisites }
  #  it('should return INF135 as a prerequisite and MEC329 as a prerequisite or a concurrent course') { should == and_relation }
  #end
  #
  #context '(MAT265, MEC222, MEC423)' do
  #  let!(:prerequisites) { { prerequisite: %w(MAT265 MEC222 MEC423) } }
  #  let!(:and_relation) { relation_double :and, prerequisites }
  #  it('should return MAT265, MEC222 and MEC423 as prerequisites') { should == and_relation }
  #end
  #
  #context '(PCC310 ou PCC317)' do
  #  let!(:prerequisites) { { prerequisite: %w(PCC310 PCC317) } }
  #  let!(:or_relation) { relation_double :or, prerequisites }
  #  it('should return PCC310 or PCC317 as a prerequisite') { should == or_relation }
  #end

  context '(GPA205, sauf profil P)' do
  end

  context '(ELE340; profil E: INF145)' do
  end

  context '(profils A et C CTN103)' do
  end

  context '(profils AD, I et R: GOL102)' do
  end

  context '(profils I, M et P : GPA325)' do
  end

  context '(profil B : CTN100; profils A et C : CTN100, CTN103)' do
  end

  context '(profil E : GPA305, ING150; profils I, M et P : ING150)' do
  end

  context '(profils A et B : CHM131, CTN104; profil C : CHM131)' do
  end

  context '(profils A et B : CTN104, CTN308, CTN426; profil C : CTN308, CTN426)' do
  end

  context '(profils E, I et M : GPA205, GPA430; profil P : GPA430)' do
  end

  context '(PCS310 et avoir obtenu au moins 6 crédits de cours dans la concentration Technologies de la santé)' do
  end

  context '(PCS310 et avoir obtenu au moins 6 crédits de cours de la concentration Technologies de la santé)' do
  end

  context '(avoir obtenu au moins 6 crédits de cours de la concentration Technologies de la santé)' do
  end

  context '(90 crédits cumulés)' do
  end
end
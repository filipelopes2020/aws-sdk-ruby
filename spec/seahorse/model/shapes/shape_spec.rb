# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

module Seahorse
  module Model
    module Shapes

      describe Shape do

        describe 'from_hash_class' do

          it 'fails if shape is not registered' do
            expect do
              Shape.from_hash_class('type' => 'invalid')
            end.to raise_error(/Unregistered shape type invalid/)
          end

        end

      end

      describe ListShape do

        it 'deserializes members property' do
          shape = Shape.from_hash 'members' => {
            'type' => 'structure',
            'members' => {
              'property' => { 'type' => 'string' }
            }
          }, 'type' => 'list'
          expect(shape).to be_instance_of ListShape
          expect(shape.members).to be_instance_of StructureShape
          expect(shape.members.members[:property]).to be_instance_of StringShape
        end

      end

      describe MapShape do

        it 'deserializes keys and members properties' do
          shape = Shape.from_hash 'keys' => {
            'type' => 'string'
          }, 'members' => {
            'type' => 'structure',
            'members' => {
              'property' => { 'type' => 'string' }
            }
          }, 'type' => 'map'

          expect(shape).to be_instance_of MapShape
          expect(shape.keys).to be_instance_of StringShape
          expect(shape.members).to be_instance_of StructureShape
          expect(shape.members.members[:property]).to be_instance_of StringShape
        end

      end

      describe StructureShape do

        it 'defaults to an empty members hash' do
          shape = StructureShape.new
          expect(shape.members).to eq({})
        end

        it 'provides a hash of members by their serialized names' do
          shape = Shape.from_hash(
            'type' => 'structure',
            'members' => {
              'abc' => { 'type' => 'string', 'serialized_name' => 'AbC' },
              'xyz' => { 'type' => 'string', 'serialized_name' => 'xYz' },
            }
          )
          expect(shape.members[:abc]).to be(shape.serialized_members['AbC'])
          expect(shape.members[:xyz]).to be(shape.serialized_members['xYz'])
        end

      end
    end
  end
end

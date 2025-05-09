// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package journal

import (
	"context"
)

type contextKey string

const RecorderKey contextKey = "journal-recorder"

// RecorderFromContext extracts the recorder from the given context
func RecorderFromContext(ctx context.Context) Recorder {
	recorder, ok := ctx.Value(RecorderKey).(Recorder)
	if !ok {
		return &LogRecorder{}
	}
	return recorder
}

// ContextWithRecorder adds the recorder to the given context
func ContextWithRecorder(ctx context.Context, recorder Recorder) context.Context {
	return context.WithValue(ctx, RecorderKey, recorder)
}

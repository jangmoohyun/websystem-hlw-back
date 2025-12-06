import axios from "axios";

// Judge0 클라이언트 유틸리티
// 환경변수 JUDGE0_URL을 통해 Judge0 엔드포인트를 지정합니다. (로컬/자체 인스턴스 권장)
const JUDGE0_URL = process.env.JUDGE0_URL || "https://judge0.p.rapidapi.com";
const DEFAULT_TIMEOUT = 60000; // 타임아웃 기본값 (ms)

// 문자열을 base64로 인코딩합니다. Judge0에 base64_encoded=true로 요청할 때 사용합니다.
function b64(s) {
  return Buffer.from(s ?? "", "utf8").toString("base64");
}

/**
 * 여러 테스트케이스를 병렬로 Judge0에 제출하여 실행 결과를 반환합니다.
 * - sourceCode: 제출 코드
 * - languageId: Judge0의 language_id
 * - testCases: [{ input, expected }, ...]
 * 반환: [{ input, expected, stdout, stderr, compile, status, time, memory }, ...]
 */
export async function runMultipleTestsBase64(
  sourceCode,
  languageId,
  testCases
) {
  // testCases 유효성 검사
  if (!Array.isArray(testCases) || testCases.length === 0) return [];

  // Prepare headers; include RapidAPI key/host if provided in env
  const reqHeaders = { "Content-Type": "application/json" };
  if (process.env.JUDGE0_API_KEY) {
    reqHeaders["X-RapidAPI-Key"] = process.env.JUDGE0_API_KEY;
  }
  if (process.env.JUDGE0_API_HOST) {
    reqHeaders["X-RapidAPI-Host"] = process.env.JUDGE0_API_HOST;
  }

  const promises = testCases.map((tc) => {
    const payload = {
      source_code: b64(sourceCode),
      language_id: languageId,
      stdin: b64(tc.input ?? ""),
    };
    // wait=true로 동기 응답을 받고 base64 결과를 사용
    return axios.post(
      `${JUDGE0_URL}/submissions?wait=true&base64_encoded=true`,
      payload,
      {
        headers: reqHeaders,
        timeout: DEFAULT_TIMEOUT,
      }
    );
  });

  let responses;
  try {
    // DEBUG: log a short preview of the source being sent (decoded)
    try {
      const preview = Buffer.from(b64(sourceCode), "base64")
        .toString("utf8")
        .slice(0, 1000);
      console.debug("Judge0Client submitting source preview:", preview);
    } catch (e) {
      console.debug("Judge0Client failed to prepare source preview", e);
    }
    responses = await Promise.all(promises);
  } catch (err) {
    // Bubble up a helpful error with status/response if available
    if (err.response && err.response.data) {
      const msg =
        err.response.data.message || JSON.stringify(err.response.data);
      throw new Error(`Judge0 request failed: ${msg}`);
    }
    throw err;
  }
  return responses.map((r, i) => {
    const d = r.data ?? {};
    const stdout = d.stdout
      ? Buffer.from(d.stdout, "base64").toString("utf8")
      : "";
    const stderr = d.stderr
      ? Buffer.from(d.stderr, "base64").toString("utf8")
      : "";
    const compile = d.compile_output
      ? Buffer.from(d.compile_output, "base64").toString("utf8")
      : "";

    return {
      input: testCases[i].input,
      expected: testCases[i].expected,
      stdout,
      stderr,
      compile,
      status: d.status?.description ?? null,
      time: d.time ?? null,
      memory: d.memory ?? null,
    };
  });
}

// 간단한 출력 정규화 함수: CR 제거 및 trim
export function normalizeOutput(s) {
  return (s ?? "").replace(/\r/g, "").trim();
}

export default { runMultipleTestsBase64, normalizeOutput };

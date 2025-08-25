import argparse
import kfp


def main(host: str, pipeline_path: str) -> None:
    client = kfp.Client(host=host)
    experiment = client.create_experiment("demo")
    run = client.run_pipeline(experiment.id, "test-run", pipeline_path)
    print("Started run:", run.id)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="http://localhost:8888", help="KFP API endpoint")
    parser.add_argument("--pipeline", default="test_pipeline.yaml", help="Path to pipeline package")
    args = parser.parse_args()
    main(args.host, args.pipeline)

resource "aws_subnet" "public" {
  count = "${length(var.vpc_cidrs_public)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(data.aws_availability_zones.main.names,count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_public,count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.environment_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.vpc_cidrs_private)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(data.aws_availability_zones.main.names,count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_private,count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.environment_name}-private-${count.index}"
  }
}
